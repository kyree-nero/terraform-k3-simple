This is a simple rancher k3 install over aws.

You should change the cidr block in terraform.tfVars to use your own ip and not leave it wide open if you are going to leave it up for more than a few minutes.

It will trigger a t3.micro instance in stockholm as that is free in that region currently.

Happy coding...