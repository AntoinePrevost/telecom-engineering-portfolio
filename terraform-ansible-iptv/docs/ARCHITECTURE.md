# System Architecture Documentation

## Overview

This document describes the comprehensive architecture of the IPTV streaming infrastructure, including network topology, security design, component interactions, and data flow patterns.

## 🏛️ High-Level Architecture

```
Internet
    ↓
┌─────────────────────────────────────────────────────────────────┐
│                        AWS VPC                                 │
│                                                                │
│  ┌─────────────────── Public Subnet ──────────────────────┐   │
│  │                                                         │   │
│  │  ┌─────────────┐            ┌─────────────────────┐    │   │
│  │  │   Bastion   │            │   Load Balancer     │    │   │
│  │  │   Host      │◄──────────►│   (Nginx + SSL)     │    │   │
│  │  │             │            │                     │    │   │
│  │  └─────────────┘            └─────────────────────┘    │   │
│  │         │                              │              │   │
│  └─────────│──────────────────────────────│──────────────┘   │
│           │                              │                  │
│  ┌────────│──── Private Subnet 1 ────────│─────────────┐    │
│  │        │                              │             │    │
│  │        ▼                              ▼             │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │    │
│  │  │ Frontend-0  │  │ Frontend-1  │  │ Frontend-N  │  │    │
│  │  │ (Nginx+RTMP)│  │ (Nginx+RTMP)│  │ (Nginx+RTMP)│  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │    │
│  │         ▲                ▲                ▲         │    │
│  └─────────│────────────────│────────────────│─────────┘    │
│           │                │                │              │
│  ┌────────│──── Private Subnet 2 ───────────│──────────┐   │
│  │        │                                 │          │   │
│  │        │           RTMP Streams          │          │   │
│  │        │              (Port 1935)       │          │   │
│  │        │                                 │          │   │
│  │  ┌─────▼─────┐  ┌─────────────┐  ┌──────▼──────┐   │   │
│  │  │ Backend-0 │  │ Backend-1   │  │ Backend-N   │   │   │
│  │  │ (FFmpeg)  │  │ (FFmpeg)    │  │ (FFmpeg)    │   │   │
│  │  └───────────┘  └─────────────┘  └─────────────┘   │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 🌐 Network Architecture

### VPC Configuration
- **CIDR Block**: Defined by `vpc_name` variable
- **Region**: us-east-1
- **Availability Zone**: Single AZ deployment for simplicity

### Subnet Design

#### Public Subnet (10.0.0.0/18)
- **Purpose**: Internet-facing resources
- **Components**: Bastion host, Load balancer
- **Internet Gateway**: Direct internet access
- **Security**: Controlled access via security groups

#### Private Subnet 1 (10.0.128.0/18)
- **Purpose**: Frontend streaming servers
- **Components**: Nginx RTMP servers
- **Internet Access**: Via bastion host NAT
- **Security**: No direct internet access

#### Private Subnet 2 (10.0.192.0/18)
- **Purpose**: Backend processing servers  
- **Components**: FFmpeg video processors
- **Internet Access**: Via bastion host NAT
- **Security**: Most restrictive access

### Routing Configuration

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Public Route    │    │ Private Route 1 │    │ Private Route 2 │
│ Table           │    │ Table           │    │ Table           │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ 0.0.0.0/0 →     │    │ 0.0.0.0/0 →     │    │ 0.0.0.0/0 →     │
│ Internet GW     │    │ Bastion ENI     │    │ Bastion ENI     │
│                 │    │ (Private 1)     │    │ (Private 2)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🖥️ Component Architecture

### Bastion Host
```
┌─────────────────────────────────────────────────────────────┐
│                    Bastion Instance                         │
├─────────────────────────────────────────────────────────────┤
│ Interfaces:                                                 │
│ • eth0: Public subnet (SSH access from internet)           │
│ • eth1: Private subnet 1 (NAT for frontend servers)        │
│ • eth2: Private subnet 2 (NAT for backend servers)         │
├─────────────────────────────────────────────────────────────┤
│ Functions:                                                  │
│ • SSH Jump host for private instances                       │
│ • NAT Gateway for private subnets                          │
│ • IP forwarding enabled                                     │
│ • Source/dest check disabled on private interfaces         │
└─────────────────────────────────────────────────────────────┘
```

### Load Balancer
```
┌─────────────────────────────────────────────────────────────┐
│                  Load Balancer Instance                     │
├─────────────────────────────────────────────────────────────┤
│ Services:                                                   │
│ • Nginx reverse proxy                                       │
│ • Let's Encrypt SSL/TLS termination                        │
│ • HTTP → HTTPS redirection                                  │
│ • Upstream load balancing to frontend servers              │
├─────────────────────────────────────────────────────────────┤
│ Configuration:                                              │
│ • Port 80: HTTP (redirects to HTTPS)                       │
│ • Port 443: HTTPS with SSL certificates                    │
│ • Upstream: Round-robin to frontend servers                │
└─────────────────────────────────────────────────────────────┘
```

### Frontend Servers
```
┌─────────────────────────────────────────────────────────────┐
│                   Frontend Server (x N)                    │
├─────────────────────────────────────────────────────────────┤
│ Services:                                                   │
│ • Nginx with RTMP module                                   │
│ • HTTP server for web interface                            │
│ • RTMP stream receiver                                     │
├─────────────────────────────────────────────────────────────┤
│ Ports:                                                      │
│ • 80: HTTP (served to load balancer)                       │
│ • 1935: RTMP (receives from backend servers)              │
├─────────────────────────────────────────────────────────────┤
│ Content:                                                    │
│ • Static HTML interface                                     │
│ • Live stream endpoints                                     │
│ • Stream statistics and monitoring                          │
└─────────────────────────────────────────────────────────────┘
```

### Backend Servers
```
┌─────────────────────────────────────────────────────────────┐
│                   Backend Server (x N)                     │
├─────────────────────────────────────────────────────────────┤
│ Services:                                                   │
│ • FFmpeg video processing                                   │
│ • Video file storage                                        │
│ • RTMP streaming client                                     │
├─────────────────────────────────────────────────────────────┤
│ Functions:                                                  │
│ • Video encoding and processing                             │
│ • Stream loop management                                    │
│ • Multi-destination streaming                               │
├─────────────────────────────────────────────────────────────┤
│ Sample Content:                                             │
│ • Big Buck Bunny demo video (obrey.mp4)                   │
│ • Looped streaming to all frontend servers                 │
└─────────────────────────────────────────────────────────────┘
```

## 🔐 Security Architecture

### Network Security Layers

#### Layer 1: Internet Gateway Protection
- Only public subnet has direct internet access
- Private subnets isolated from direct internet exposure

#### Layer 2: Security Groups (Stateful Firewall)

```
┌─────────────────────────────────────────────────────────────┐
│                    Security Group Matrix                    │
├─────────────────┬─────────────┬─────────────┬─────────────────┤
│ Component       │ Inbound     │ Source      │ Ports           │
├─────────────────┼─────────────┼─────────────┼─────────────────┤
│ Bastion Public  │ SSH         │ 0.0.0.0/0   │ 22              │
│ Bastion Priv 1  │ All Traffic │ 10.0.128/18 │ All             │
│ Bastion Priv 2  │ All Traffic │ 10.0.192/18 │ All             │
│ Load Balancer   │ HTTP/HTTPS  │ 0.0.0.0/0   │ 80, 443         │
│                 │ SSH         │ Bastion IP  │ 22              │
│ Frontend        │ HTTP        │ LB IP       │ 80              │
│                 │ RTMP        │ Priv Sub 2  │ 1935            │
│                 │ SSH         │ Bastion IP  │ 22              │
│ Backend         │ SSH         │ Bastion IP  │ 22              │
├─────────────────┼─────────────┼─────────────┼─────────────────┤
│ All Components  │ All Traffic │ 0.0.0.0/0   │ All (Egress)    │
└─────────────────┴─────────────┴─────────────┴─────────────────┘
```

#### Layer 3: SSH Key Management
- Separate key pairs for bastion and instances
- Automated key generation and distribution
- Proper file permissions (0400)
- Keys stored locally and in AWS Key Pairs

### SSL/TLS Security
- Automatic Let's Encrypt certificate provisioning
- HTTPS enforcement with HTTP redirection  
- Certificate auto-renewal capability
- Strong cipher suites and protocols

## 📊 Data Flow Architecture

### Client Request Flow
1. **DNS Resolution**: `streaming.domain.com` → Load Balancer Public IP
2. **SSL Handshake**: Client ↔ Load Balancer (Certificate validation)
3. **Load Balancing**: Request distributed to available frontend server
4. **Content Delivery**: Frontend serves web interface and stream links

### Video Streaming Flow
1. **Source Processing**: Backend servers encode video with FFmpeg
2. **RTMP Publishing**: Streams pushed to frontend servers (port 1935)
3. **Stream Serving**: Frontend servers make streams available via HTTP/HLS
4. **Client Consumption**: Clients access streams through load balancer

### Management Access Flow
1. **SSH to Bastion**: Admin connects to bastion host (public IP)
2. **Jump to Private**: SSH tunnel through bastion to private instances
3. **Configuration**: Ansible automation via bastion proxy commands

## 🔄 Automation Architecture

### Infrastructure as Code (Terraform)
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Variables     │    │   Resources     │    │    Outputs      │
│   Definition    │───▶│   Provisioning  │───▶│   Information   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       ▼                       │
         │              ┌─────────────────┐              │
         │              │  Configuration  │              │
         └─────────────▶│  File Generation│◄─────────────┘
                        └─────────────────┘
                                │
                                ▼
                     ┌─────────────────────┐
                     │  Ansible Inventory  │
                     │  & Configuration    │
                     └─────────────────────┘
```

### Configuration Management (Ansible)
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Inventory     │    │    Playbook     │    │     Roles       │
│   (Generated)   │───▶│   Execution     │───▶│  Configuration  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       ▼                       │
         │              ┌─────────────────┐              │
         └─────────────▶│  Task Execution │◄─────────────┘
                        │  on Target Hosts│
                        └─────────────────┘
```

## 📈 Scalability Considerations

### Horizontal Scaling
- Frontend servers: Configurable via `nombre_instance_front`
- Backend servers: Configurable via `nombre_instance_back`
- Load balancer automatically discovers new frontend servers
- Backend servers automatically stream to all frontends

### Performance Optimization
- Instance types configurable per component
- Geographic distribution possible with multi-AZ deployment
- CDN integration potential for global distribution

## 🔍 Monitoring and Observability

### Log Aggregation Points
- Nginx access logs on load balancer and frontend servers
- FFmpeg process logs on backend servers
- System logs accessible via centralized logging

### Health Check Mechanisms
- Load balancer health checks to frontend servers
- Process monitoring for critical services
- Network connectivity validation

This architecture provides a robust, secure, and scalable foundation for IPTV streaming services while demonstrating enterprise-level DevOps practices and security implementations.