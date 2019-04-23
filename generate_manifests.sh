#!/usr/bin/env bash

function show_help() {
  echo "Generate Kubernetes manifests from helm chart."
  echo
  echo "options:"
  echo "-h, --help              Show brief help."
  echo "-v, --values            Specify the values file. DEFAULT: values.yaml."
  echo "-o, --output-file=FILE  Specify the output file."
  echo
  echo "example:"
  echo "  $0 -v my_values.yaml -o generated/kubernetes/production.yaml"
  exit 0
}

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      show_help
      ;;
    -v)
      shift
      if test $# -gt 0; then
        export VALUES=$1
      else
        echo "no output file specified"
        exit 1
      fi
      shift
      ;;
    --values*)
      export VALUES=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -o)
      shift
      if test $# -gt 0; then
        export OUTPUT=$1
      else
        echo "no output file specified"
        exit 1
      fi
      shift
      ;;
    --output-file*)
      export OUTPUT=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done

# enforce required flags
if [[ -z "$OUTPUT" ]];then
  echo "output is required!"
  echo
  show_help
  exit 1
fi

# set values.yaml as default values file if not given
if [[ -z "$VALUES" ]];then
  export VALUES=values.yaml
fi

# ensure we're in the correct directory
cd $(dirname $0)

# write out manifests
echo "writing generated manifests to $OUTPUT"
helm template . --values="$VALUES" > "$OUTPUT"

