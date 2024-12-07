  # LinuxBenchHub
Performance benchmarking of various Linux distributions using virtual machines (VMs) with detailed results and analysis

# Linux Distro Benchmarking Using VMs

This repository contains performance benchmarks of various Linux distributions running in virtual machines (VMs). The goal is to evaluate and compare the performance of these distributions based on a variety of metrics, helping developers and enthusiasts choose the most suitable distro for their virtualized environments.

## 📝 Project Overview

With the rapid evolution of Linux distributions, it is important to assess how different distros perform in virtualized environments. This project benchmarks several popular Linux distros running inside VMware Fusion Pro 13.6.1 virtual machines.

## ⚙️ Tools and Setup

- **VM Platform**: VMware Fusion Pro 13.6.1
- **Benchmarking Tool**: Phoronix Test Suite
- **Operating Systems**: Various Linux distributions, including:
  - Ubuntu 22.04 LTS
  - Fedora 40
  - Debian 12
- **Metrics Evaluated**:
  - CPU Performance
  - Memory Usage
  - Disk I/O
  - Network Throughput
  - Boot Time

## 📊 Benchmark Results

You can find detailed benchmarking results for each distribution in the respective folders below:

| Distribution      | CPU Performance | Memory Usage | Network Throughput | Boot Time |
|-------------------|-----------------|--------------|--------------------|-----------|
| [Ubuntu](./benchmarks/ubuntu.md)     | ✅               | ✅            | ✅                  | ✅         |
| [Fedora](./benchmarks/fedora.md)     | ✅               | ✅            | ✅                  | ✅         |
| [Debian](./benchmarks/debian.md)     | ✅               | ✅            | ✅                  | ✅         |

*For detailed data, refer to the [benchmarks](./benchmarks) folder.*

### Sample Graphs and Visualizations

![CPU Performance Comparison](./images/cpu_performance.png)

## 📁 Repository Structure

