TARGET ?= wendellsun/protoc

build:
	docker build -t $(TARGET) .

push:
	docker push $(TARGET)
