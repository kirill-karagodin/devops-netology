# Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
    service_account_id = "${var.sa-bucket}"
    description        = "static access key for bucket"
}

# Use keys to create bucket
resource "yandex_storage_bucket" "netology-bucket" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = "karagodin-netology-bucket"
    acl    = "public-read"
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id = yandex_kms_symmetric_key.key-a.id
                sse_algorithm     = "aws:kms"
            }
        }
    }
}

# Add picture to bucket
resource "yandex_storage_object" "object-1" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = yandex_storage_bucket.netology-bucket.bucket
    key = "test.jpg"
    source = "data/test.jpg"
    acl    = "public-read"
    depends_on = [yandex_storage_bucket.netology-bucket]
}
