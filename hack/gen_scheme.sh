#!/usr/bin/env bash
# Copyright 2024 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

DIR="$(dirname "${BASH_SOURCE[0]}")"
ROOT_DIR="$(realpath "${DIR}/..")"

function gen() {
  cat <<EOF
/*
Copyright The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package scheme

// Don't edit this file directly. It is generated by gen_scheme.sh.
import (
EOF

  find "${ROOT_DIR}/vendor/k8s.io/api" | grep register.go | sed "s#${ROOT_DIR}/vendor/##g" | sed "s#/register.go##g" | awk -F '/' '{print "	"$3$4, "\""$1"\/"$2"\/"$3"\/"$4"\""}' | sort

  cat <<EOF
	"k8s.io/apimachinery/pkg/runtime"
)

// AddToScheme adds all types of this clientset into the given scheme.
func AddToScheme(scheme *runtime.Scheme) {
EOF

  find "${ROOT_DIR}/vendor/k8s.io/api" | grep register.go | sed "s#${ROOT_DIR}/vendor/##g" | sed "s#/register.go##g" | awk -F '/' '{print "	_ = " $3$4"\.AddToScheme(scheme)"}' | sort

  cat <<EOF
}
EOF
}

gen
