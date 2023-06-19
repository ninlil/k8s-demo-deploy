build:
	mkdir -p bin
	CGO_ENABLED=0 go build -ldflags "-s -w" -o bin/demo .

compare:
	CGO_ENABLED=0 go build -o bin/demo_clean .
	CGO_ENABLED=0 go build -ldflags "-s" -o bin/demo_ld_s .
	CGO_ENABLED=0 go build -ldflags "-w" -o bin/demo_ld_w .
	CGO_ENABLED=0 go build -ldflags "-s -w" -o bin/demo_ld_sw .

clean:
	-rm bin/demo_*

size:
	ls -la bin/demo_*

docker:
	docker build -t demo:latest .