This is a simple rancher k3 install over aws.

1. You should change the cidr block in terraform.tfVars to use your own ip and not leave it wide open if you are going to leave it up for more than a few minutes.
1. Run terraform apply --auto-approve

It will trigger a t3.micro instance in stockholm as that is free in that region currently.

Happy coding...