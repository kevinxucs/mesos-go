PROTO_PATH := ${GOPATH}/src/:./vendor/:.
PROTO_PATH := ${PROTO_PATH}:./vendor/github.com/gogo/protobuf/protobuf
PROTO_PATH := ${PROTO_PATH}:./vendor/github.com/gogo/protobuf/gogoproto

.PHONY: test protobufs

all: test

test:
	go test $$(go list ./...|grep -v vendor)

codecs: protobufs ffjson

protobufs: clean-protobufs
	protoc --proto_path="${PROTO_PATH}" --gogo_out=. *.proto
	protoc --proto_path="${PROTO_PATH}" --gogo_out=. ./scheduler/*.proto

clean-protobufs:
	-rm *.pb.go **/*.pb.go

ffjson: clean-ffjson
	ffjson *.pb.go
	ffjson **/*.pb.go

clean-ffjson:
	-rm *ffjson.go **/*ffjson.go
