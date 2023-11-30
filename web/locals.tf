locals {
  workspace_sufix = terraform.workspace == "default" ? "" : "${terraform.workspace}"
  rg_name = "${var.rg_name}-${local.workspace_sufix}"
  source_content = "${var.source_content} <br>Workspace: ${terraform.workspace}"
}