provider "aws" {
  profile    = "default"
  region     = "eu-central-1"
}

resource "aws_instance" "example" {
  ami           = "ami-09356619876445425"
  instance_type = "t2.micro"
}
