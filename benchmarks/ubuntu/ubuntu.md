# Ubuntu Benchmark Results

This document provides detailed benchmarking results for Ubuntu 24.04 running in a VMware Fusion Pro 13.6.1 virtual machine. The benchmarks were conducted using the Phoronix Test Suite.

## System Information

#### Hardware
- **Processor**: 2 x Intel Core i5-7360U (3 Cores)
- **Motherboard**: Intel VMware Virtual 440BX Desktop (6.00 BIOS)
- **Chipset**: Intel 440BX/ZX/DX
- **Memory**: 4096MB
- **Disk**: 21GB VMware Virtual S
- **Graphics**: VMware SVGA II
- **Audio**: Ensoniq ES1371/ES1373
- **Network**: Intel 82545EM

#### Software
- **OS**: Ubuntu 24.04
- **Kernel**: 6.8.0-49-generic (x86_64)
- **Desktop**: GNOME Shell 46.0
- **Display Server**: X Server 1.21.1.11 + Wayland
- **Compiler**: GCC 13.2.0
- **File-System**: ext4
- **Screen Resolution**: 1280x800
- **System Layer**: VMware
- **Timestamp**: 2024-12-07 14:28:03

---

## Test Results: C-Ray Benchmark

### Test Identifier: `pts/c-ray-2.0.0`

#### Title: C-Ray
- **App Version**: 2.0
- **Arguments**: `-s 1920x1080 -r 16`
- **Description**: Resolution: 1080p - Rays Per Pixel: 16
- **Scale**: Seconds
- **Display Format**: BAR_GRAPH

---

### Data Entries
- **Identifier**: CPU
- **Value (Seconds)**: 1077.898
- **Raw String (Milliseconds)**: `1244.257:767.61:869.845:1156.015:1447.948:1055.703:1221.001:1141.11:797.595`

---

### Detailed Run Times

| Run | Time (ms) |
|-----|-----------|
| 1   | 1244.257  |
| 2   | 767.610   |
| 3   | 869.845   |
| 4   | 1156.015  |
| 5   | 1447.948  |
| 6   | 1055.703  |
| 7   | 1221.001  |
| 8   | 1141.110  |
| 9   | 797.595   |

---

### Visualization
![c-ray_benchmark_results](https://github.com/user-attachments/assets/ce014451-a311-4c19-b59f-d83a3143d902)

## Test Results: Tinymembench Benchmark

### Test Identifier: `pts/tinymembench-1.0.2`
