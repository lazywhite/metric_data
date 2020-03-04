//
// Copyright (C) 2020 white <white@Whites-Mac-Air.local>
//
// Distributed under terms of the MIT license.
//

package main

import (
    "flag"
    "time"
    "errors"
    "log"
    "net/http"
    "os"
    //"reflect"
    "encoding/json"
    "fmt"
    "crypto/tls"

    "github.com/gorilla/handlers"
    "github.com/gorilla/mux"
    "github.com/Nerzal/gocloak/v4"
    "github.com/go-resty/resty/v2"
)

var (
    bind string
    port int
)


//get keycloak openid
func authUser(token string) (*gocloak.UserInfo, error){
    if token == ""{
        return nil, errors.New("no authorization header provided")
    }
    realmName := os.Getenv("REALM_NAME")
    serverURL := os.Getenv("SERVER_URL")

    client := gocloak.NewClient(serverURL)
    restyClient := client.RestyClient()
    //restyClient.SetDebug(true)
    restyClient.SetTLSClientConfig(&tls.Config{ InsecureSkipVerify: true })

    userInfo, _err := client.GetUserInfo(token, realmName)
    if _err != nil{
        return nil, errors.New("invalid token")
    }else{
        return userInfo, nil
    }
}

func getLogFile(name string) *os.File {
    logFile, err := os.OpenFile(name, os.O_WRONLY|os.O_APPEND|os.O_CREATE, 0666)
    if err != nil {
        log.Fatalln("open file error !")
    }
    return logFile
}

func getMetricData(startTS string, endTS string, metric string, username string) ([]byte, error) {
    apiURL := os.Getenv("PROMETHEUS_URL")
    podPrefix := os.Getenv("POD_PREFIX")
    nsPrefix := os.Getenv("NAMESPACE_PREFIX")
    cName := os.Getenv("CONTAINER_NAME")
    var queryString string
    if metric == "cpu"{
        queryString = fmt.Sprintf(`query=avg(rate(container_cpu_usage_seconds_total{container="%s",container!="POD",namespace="%s%s",pod="%s%s"}[5m]))&start=%s&end=%s&step=15`, cName, nsPrefix, username, podPrefix, username, startTS, endTS)
    }
    if metric == "mem"{
        queryString = fmt.Sprintf(`query=container_memory_usage_bytes{container="%s",container!="POD",namespace="%s%s",pod="%s%s"} / container_spec_memory_limit_bytes{container="%s",container!="POD",namespace="%s%s",pod="%s%s"}&start=%s&end=%s&step=15`, cName, nsPrefix, username, podPrefix, username, cName, nsPrefix, username, podPrefix, username, startTS, endTS)
    }
    path := apiURL + "/query_range"

    client := resty.New()
    resp, err := client.
                    SetTimeout(3 * time.Second).
                    R().
                    EnableTrace().
                    SetHeader("Accept", "application/json").
                    SetQueryString(queryString).
                    Get(path)

    fmt.Println(client.R().URL)
    if err == nil && resp.StatusCode() == 200{
        return resp.Body(), nil
    }else{
        return resp.Body(), errors.New("failed to get metric data")
    }

}

func metricHandler(w http.ResponseWriter, r *http.Request) {
    token := r.Header.Get("Authorization")
    //1. auth user
    userInfo, err := authUser(token);
    if  err == nil{
        // 2. parse query argument
        args := r.URL.Query()
        //fmt.Println(args)
        startTS, ok := args["startts"]
        if !ok || len(startTS) != 1{
            json.NewEncoder(w).Encode(map[string]interface{}{"status": 2, "msg": "no start timestamp provided or given too much"})
        }
        endTS, ok := args["endts"]
        if  !ok || len(endTS) != 1{
            json.NewEncoder(w).Encode(map[string]interface{}{"status": 3, "msg": "no end timestamp provided or given too much"})
        }
        metric, ok := args["metric"]
        if !ok || len(metric) != 1{
            json.NewEncoder(w).Encode(map[string]interface{}{"status": 4, "msg": "no metric name provided or given too much"})
        }
        data, err := getMetricData(startTS[0], endTS[0], metric[0], *userInfo.PreferredUsername)
        if err == nil{
            w.Write(data)
        }else{
            json.NewEncoder(w).Encode(map[string]interface{}{"status": 5, "msg": err.Error()})
        }
    }else{
        json.NewEncoder(w).Encode(map[string]interface{}{"status": 6, "msg": err.Error()})

    }
}

func usage() {
    fmt.Fprintf(os.Stderr, `get metric data from prometheus
Usage: metric_data [-h] [-b bind] [-p port]

Options:
`)
    flag.PrintDefaults()
}

func init(){
    flag.StringVar(&bind, "b", "127.0.0.1", "bind ip")
    flag.IntVar(&port, "p", 10000, "bind port")
    flag.Usage = usage
}
func main() {
    flag.Parse()

    address := fmt.Sprintf("%s:%d", bind, port)
    accessLogFile := getLogFile("/tmp/.access.log")
    defer accessLogFile.Close()

    r := mux.NewRouter().StrictSlash(true)
    r.HandleFunc("/metric", metricHandler).Methods("GET")
    loggedRouter := handlers.LoggingHandler(accessLogFile, r)

    fmt.Println("serving on :" + address)
    http.ListenAndServe(address, loggedRouter)
}


