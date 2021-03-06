#! /bin/bash
#
# curl.sh
# Copyright (C) 2020 white <white@Whites-Mac-Air.local>
#
# Distributed under terms of the MIT license.
#
token=eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJuU3NjeDE5QXZVNGo3ekl3elJnenE1SEVVTWU4UWN5aV8xMjFJdjJubnpRIn0.eyJqdGkiOiJhMDhhODQ3ZC02MDgxLTQ0MTAtOWMwMS02MDIxODU2ZWFlZDkiLCJleHAiOjE1ODQxNzQwNjMsIm5iZiI6MCwiaWF0IjoxNTg0MTMwODY0LCJpc3MiOiJodHRwczovL2FjY291bnQuYXZhaWxpbmsuY29tL2F1dGgvcmVhbG1zL2F2bGNsb3VkIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6IjhjODBkMTU4LWI0M2ItNDNkNy04ZjdiLTUzZGZlMDhmODc2ZCIsInR5cCI6IkJlYXJlciIsImF6cCI6ImF2bGNsb3VkIiwiYXV0aF90aW1lIjoxNTg0MTMwODYzLCJzZXNzaW9uX3N0YXRlIjoiY2E3ZWMxNWYtYTIyZi00NzRjLTg4NjItNDhkNWExMDcwZTA2IiwiYWNyIjoiMSIsImFsbG93ZWQtb3JpZ2lucyI6WyJodHRwczovL21lZC5hdmFpbGluay5jb20iLCJodHRwczovL2ZvcnVtLmF2YWlsaW5rLmNvbSIsImh0dHA6Ly8xMC4yMDkuMTU2LjIxMDozMTU1NyIsImh0dHBzOi8vY2xvdWQuYXZhaWxpbmsuY29tIiwiaHR0cDovL2xvY2FsaG9zdDo0MzAwIiwiaHR0cDovLzEwLjIwOS4xNTYuMjQ1OjMwNzE4IiwiaHR0cDovL2Nsb3VkLmF2YWlsaW5rLmNvbSIsImh0dHA6Ly9sb2NhbGhvc3Q6NDIwMCIsImh0dHA6Ly8xMC4yMDkuMTU2LjI0MzozMjE2MCIsImh0dHBzOi8vYWkuYXZhaWxpbmsuY29tIiwiaHR0cDovLzEwLjIwOS4xNTYuMjEwOjMwNTE5IiwiaHR0cDovL2xvY2FsaG9zdDo4MDgwIiwiaHR0cHM6Ly8xMC4yMDkuMTU2LjI0MzozMDc2NyIsImh0dHA6Ly9haS5hdmFpbGluay5jb20iLCJodHRwOi8vMTAuMjA5LjE1Ni4yNDM6MzI1ODgiLCJodHRwOi8vMTAuMjA5LjE1Ni4yNDM6MzA0NDMiLCJodHRwOi8vMTAuMjA5LjE1Ni4yNDM6MzA3NjciXSwicmVzb3VyY2VfYWNjZXNzIjp7ImF2bGNsb3VkIjp7InJvbGVzIjpbIm5vcm1hbC11c2VyIl19LCJhY2NvdW50Ijp7InJvbGVzIjpbInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoic2h1YW54aSBqaWEiLCJncm91cHMiOltdLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJqaWFzaHVhbnhpIiwiZ2l2ZW5fbmFtZSI6InNodWFueGkiLCJmYW1pbHlfbmFtZSI6ImppYSIsImVtYWlsIjoic2h1YW54aS5qaWFAYXZhaWxpbmsuY29tIn0.aisxHGcme0oVbzmgH7TM5ISkNzhuSLodxBrXROi1n5UB_rCS8GlGwoULygMGEeLsY8qT3bkoSpWCw34zOTMMqTYcOWGM_At96FBYFK8bCoslKrNpkkZWff2OfW437ryN2ov-c19PizEH9NRgGBEDI4pn78nnyBeN5w6i9YWTvWWQrGDJiCnF-6QSWn3epW8MDQhClg-OEWiQC1dXuXpfdZqcD4EUsFpoGa4FYrU7jAJDk_Hl_4vYOGrqzNLk5iLooaTFaERffHSaB7asFdjjZnaGBK5gnYLCn9yH9rzVOoLIPD-t2Jt_iaqM3FectQ9RXWXoMNdL6yQcKLAU-OXDKA
#curl -v -XGET -H "Authorization: $token" 'http://localhost:10000/metric?metric=cpu&startts=1583725874&endts=1583729474&step=14&_=1583726629145'
#curl -v -XGET -H "Authorization: $token" 'http://localhost:10000/metric?metric=mem&startts=1583725874&endts=1583729474&step=14&_=1583726629145'

metrics="cpu_usage_percent
cpu_load
mem_usage_percent
mem_usage_bytes
gpu_usage_percent
gpu_mem_percent
gpu_fb_used"

startts=1584130343
endts=1584131572


for metric in $metrics;do
echo "========================"
echo
curl -v -XGET -H "Authorization: $token" "http://localhost:10000/metric?metric=$metric&startts=$startts&endts=$endts&step=14&_=1584127736162"
echo 
echo "========================"
done
