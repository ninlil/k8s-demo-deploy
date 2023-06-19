package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

var (
	liveStatus  = http.StatusOK
	readyStatus = http.StatusOK
	hostname    string
)

func probe(w http.ResponseWriter, r *http.Request, status *int, name string) {
	if i, err := strconv.Atoi(r.URL.Query().Get("status")); err == nil && i > 0 {
		*status = i
	}

	w.Header().Add("X-Hostname", hostname)
	w.WriteHeader(*status)
	w.Write([]byte(fmt.Sprint(name, " = ", *status == http.StatusOK)))
}

func live(w http.ResponseWriter, r *http.Request) {
	probe(w, r, &liveStatus, "live")
}

func ready(w http.ResponseWriter, r *http.Request) {
	probe(w, r, &readyStatus, "ready")
}

func home(w http.ResponseWriter, r *http.Request) {
	txt := `
	Hostname: %s
	Time: %s
	`
	w.Write([]byte(fmt.Sprintf(txt, hostname, time.Now().String())))
}

func init() {
	hostname, _ = os.Hostname()
}

func main() {
	http.HandleFunc("/live", live)
	http.HandleFunc("/ready", ready)
	http.HandleFunc("/", home)

	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err)
	}
}
