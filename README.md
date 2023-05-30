# whispercpp-rpmbuild

For local rpmbuild via podman use:

## Binaries/Libraries:

```
./build-binary.sh -d DIST -v VERSION -m MODE -r RELEASE BINARY
```

| Name    | Param | Mandatory | Values                           | Default |
|:------- |:----- |:---------:|:-------------------------------- |:------- |
| BINARY  |       | yes       | whispercpp<br>whispercpp-cublas  | -       |
| DIST    | -d    | yes       | el8, el9                         | -       |
| MODE    | -m    | no        | static, shared                   | static  |
| VERSION | -v    | no        | tag or branch                    | master  |
| RELEASE | -r    | no        | Number                           | 1       |

> `BINARY` does only accept a single argument - whispercpp or whispercpp-cublas.

Example:

```
./build-binary.sh -d el9 -v 1.4.2 -m shared -r 2 whispercpp
```

## Language Models:

```
./build-model.sh -d DIST -v VERSION -r RELEASE MODELS
```

| Name    | Param | Mandatory | Values                           | Default |
|:------- |:----- |:---------:|:-------------------------------- |:------- |
| MODELS  |       | yes       | tiny, base, small, medium, large | -       |
| DIST    | -d    | yes       | el8, el9                         | -       |
| VERSION | -v    | no        | tag or branch                    | master  |
| RELEASE | -r    | no        | Number                           | 1       |

> `MODELS` accepts mutliple model names as arguments.

Example:

```
./build-model.sh -d el9 -v master -r 2 tiny base small
```
