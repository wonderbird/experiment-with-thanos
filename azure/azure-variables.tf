# The variables in here are overwritten by command line arguments:
# terraform apply -var client_id="$CLIENT_ID" -var client_secret="$CLIENT_SECRET"
variable "client_id" {
    type = string
    default = "client_id has not been given as a command line argument"
}

variable "client_secret" {
    type = string
    default = "client_secret has not been given as a command line argument"
}
