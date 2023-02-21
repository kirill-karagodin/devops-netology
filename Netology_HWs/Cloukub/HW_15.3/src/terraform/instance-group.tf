# Create instance group
resource "yandex_compute_instance_group" "ig" {
    name               = "fixed-ig-with-balancer"
    folder_id          = var.yandex_folder_id
    service_account_id = "${var.sa-ig}"

    instance_template {
        resources {
            cores  = 2
            memory = 1
            core_fraction = 20
        }
        boot_disk {
            initialize_params {
                image_id = var.lamp-instance-image-id
            }
        }
        network_interface {
            network_id  = yandex_vpc_network.default.id
            subnet_ids  = [yandex_vpc_subnet.subnet-1.id]
            nat         = true
        }
        scheduling_policy {
            preemptible = true
        }
        metadata = {
            ssh-keys   = "centos:${file("~/.ssh/id_rsa.pub")}"
            user-data  = <<EOF
#!/bin/bash
apt install nginx -y
cd /var/www/html
echo '<html><img src="http://${yandex_storage_bucket.netology-bucket.bucket_domain_name}/test.jpg"/></html>' > index.html
cd /etc/nginx/conf.d/
echo 'server {
     server_name localhost;
	 listen 80;
	 
	 access_log /var/log/nginx/access_site.log
	 error_log /var/log/nginx/error_site.log
	 
	 location / {
	     root /var/www;
		 index index.html;
		 }
}' > site.conf
service nginx start
EOF
      }
   }

    scale_policy {
        fixed_scale {
            size = 3
        }
    }

    allocation_policy {
        zones = [var.zone]
    }

    deploy_policy {
        max_unavailable  = 1
        max_creating     = 3
        max_expansion    = 1
        max_deleting     = 1
        startup_duration = 3
    }

     health_check {
        http_options {
            port    = 80
            path    = "/"
        }
    }

    depends_on = [
        yandex_storage_bucket.netology-bucket
    ]

    load_balancer {
        target_group_name = "target-group"
    }
}
