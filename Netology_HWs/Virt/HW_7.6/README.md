# devops-netology
### performed by Kirill Karagodin
#### HW7.6 Написание собственных провайдеров для Terraform.

1. Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
https://github.com/hashicorp/terraform-provider-aws.git. Просто найдите нужные ресурсы в исходном коде и ответы на 
вопросы станут понятны.
a. Найдите, где перечислены все доступные resource и data_source, приложите ссылку на эти строки в коде на гитхабе.
[resource](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L871)  
[data_source](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/provider/provider.go#L412)
b. Для создания очереди сообщений SQS используется ресурс aws_sqs_queue у которого есть параметр name.
- С каким другим параметром конфликтует name? Приложите строчку кода, в которой это указано.
[ConflictsWith: []string{"name_prefix"}](https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L87)  
- Какая максимальная длина имени?
Максимальная длинна имени 80 символов
[Строчка кода] ((https://github.com/hashicorp/terraform-provider-aws/blob/main/internal/service/sqs/queue.go#L427) )
- Какому регулярному выражению должно подчиняться имя?
````bash
		if fifoQueue {
			re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,75}\.fifo$`)
		} else {
			re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
		}
````
