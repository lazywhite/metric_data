## Requirements
```
k8s: v1.13
```
## Usage
```
1. bash# go build; source env.sh; ./metric_data
2. bash# sh -x curl.sh

supported metric
	cpu_usage_percent
	cpu_load
	mem_usage_percent
	mem_usage_bytes
	gpu_usage_percent
	gpu_mem_percent
	gpu_fb_used  (Mib)
```

