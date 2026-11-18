# Native tests for the root module: run `terraform init -backend=false` and
# then `terraform test` from the repository root. Every run is a plan, so the
# tests create nothing and need no provider, backend, state or credentials.

run "defaults" {
  command = plan

  assert {
    condition     = output.cluster_name == "fleet"
    error_message = "The default cluster_name should be \"fleet\"."
  }

  assert {
    condition     = output.namespaces == ["fleet-system", "fleet-apps"]
    error_message = "The namespace list should be fleet-system, then fleet-apps."
  }
}

run "override" {
  command = plan

  variables {
    cluster_name = "edge-1"
  }

  assert {
    condition     = output.cluster_name == "edge-1"
    error_message = "A valid cluster_name override should reach the output unchanged."
  }
}

run "accepts_63_characters" {
  command = plan

  variables {
    # 63 characters, the longest valid label.
    cluster_name = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  }

  assert {
    condition     = length(output.cluster_name) == 63
    error_message = "A 63-character cluster_name should be accepted."
  }
}

run "rejects_invalid_cluster_name" {
  command = plan

  variables {
    cluster_name = "Bad_Name"
  }

  expect_failures = [
    var.cluster_name,
  ]
}

run "rejects_64_characters" {
  command = plan

  variables {
    # 64 characters, one more than an RFC 1123 label allows.
    cluster_name = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  }

  expect_failures = [
    var.cluster_name,
  ]
}

# main.tf `local.namespaces` is the source of truth for namespace names, so the
# base chart's namespace must be one of them.
run "chart_namespace_is_declared" {
  command = plan

  assert {
    condition     = contains(output.namespaces, yamldecode(file("charts/fleet-base/values.yaml")).namespace)
    error_message = "The namespace in charts/fleet-base/values.yaml must be one of local.namespaces in main.tf."
  }
}
