locals {
  name   = replace(basename(path.cwd), "_", "-")
  region = "ap-northeast-1"
  app    = "recruit-service-board"
}