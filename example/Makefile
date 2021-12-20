build:
	docker run -v "`pwd`":/workspace -w /workspace wendellsun/protoc --go_out=. --go_opt=paths=source_relative \
    --go-grpc_out=. --go-grpc_opt=paths=source_relative \
    helloworld.proto
