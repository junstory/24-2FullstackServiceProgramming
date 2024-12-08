output "instance_info1" {
    description = "Public IP address and ID of EC2 instance"

    value = {
        instance_id = aws_instance.ec2_instance[0].id
        instance_type = aws_instance.ec2_instance[0].instance_type
        state = aws_instance.ec2_instance[0].instance_state
        public_ip = aws_instance.ec2_instance[0].public_ip
        private_ip = aws_instance.ec2_instance[0].private_ip
        az = aws_instance.ec2_instance[0].availability_zone
    }
}



output "user_list" {
    description = "IAM User List"

    value = join(", ", [
        for name in var.user_names :
        upper(name)
    ])
}

output "access_instance" {
    value = {
        instance1 = "http://${aws_instance.ec2_instance[0].public_ip}"
        
    }
}