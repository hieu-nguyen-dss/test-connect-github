#!/bin/bash

# Hàm call_jira_api để thực hiện yêu cầu HTTP với JIRA
call_jira_api() {
  local method="$1"
  local endpoint="$2"
  local data="$3"
  
  # Gọi API Jira và lấy mã HTTP và body
  response=$(curl -s -w "%{http_code}" \
    -X "$method" \
    -H "Content-Type: application/json" \
    -u "${JIRA_EMAIL}:${JIRA_API_TOKEN}" \
    --data "$data" \
    "${JIRA_BASE_URL}${endpoint}")
  
  http_code=${response: -3}  # Mã HTTP từ phản hồi
  body=${response:0:${#response}-3}  # Body của phản hồi

  # Kiểm tra mã HTTP và in lỗi nếu có
  if [ "$http_code" -ge 400 ]; then
    echo "::error::Jira API call failed with status $http_code: $body"
    exit 1
  fi

  echo "$body"
}
