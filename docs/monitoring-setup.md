
# **Monitoring Setup Guide**

This document provides a step-by-step guide to set up monitoring for the CI/CD infrastructure using the ELK stack (Elasticsearch, Logstash, and Kibana) and Prometheus with Grafana.

---

## **1. ELK Stack Setup**

### **1.1. Install Elasticsearch**
1. Install Elasticsearch on your monitoring server:
   ```bash
   sudo apt update
   sudo apt install elasticsearch
   ```
2. Configure Elasticsearch in `/etc/elasticsearch/elasticsearch.yml`:
   ```yaml
   network.host: 0.0.0.0
   http.port: 9200
   ```
3. Start and enable the service:
   ```bash
   sudo systemctl start elasticsearch
   sudo systemctl enable elasticsearch
   ```

### **1.2. Install Logstash**
1. Install Logstash:
   ```bash
   sudo apt install logstash
   ```
2. Save the configuration in `/etc/logstash/conf.d/logstash.conf`:
   - Refer to the provided `logstash.conf` in the `monitoring/elk/` directory.
3. Start and enable the service:
   ```bash
   sudo systemctl start logstash
   sudo systemctl enable logstash
   ```

### **1.3. Install Kibana**
1. Install Kibana:
   ```bash
   sudo apt install kibana
   ```
2. Configure Kibana in `/etc/kibana/kibana.yml`:
   ```yaml
   server.host: "0.0.0.0"
   elasticsearch.hosts: ["http://localhost:9200"]
   ```
3. Start and enable the service:
   ```bash
   sudo systemctl start kibana
   sudo systemctl enable kibana
   ```

### **1.4. Configure Filebeat**
1. Install Filebeat on Jenkins and other servers:
   ```bash
   sudo apt install filebeat
   ```
2. Replace `/etc/filebeat/filebeat.yml` with the provided configuration from `monitoring/elk/filebeat.yml`.
3. Start Filebeat:
   ```bash
   sudo systemctl start filebeat
   sudo systemctl enable filebeat
   ```

---


