-- Выгрузка пользователей из базы с указанием хэша пароля и статуса УЗ

select l.LoginName Users, 
case
	when l.passwordHash = 'vFRQPemIV0HURsKLTF+tO+8uBkI=' then 'qqq111'
	when l.passwordHash = 'ws7hfnvigyEAkN113/rQkzTEBGg=' then '123'
	when l.passwordHash = 'CZInYdVykek6IMCEw9ql3DMQMG0=' then 'demo321'
	when l.passwordHash = 'LA4qU++A26qKuOlXFZVrTl1itpQ=' then 'www222'
	when l.passwordHash = '3q/vHsQzO5UwbOTSdg7AJw75q0c=' then 'admin123'
	when l.passwordHash = '3QHrhRk2AGx8op4NtDTzDZoTGzs=' then 'Admdemo'
	else l.passwordHash
end passwordHash, Discriminator, 
case
	when u.Deleted = 1 then 'DELETED'
	when u.Blocked = 1 then 'BLOCKED'
	else 'active'
end Status
 from company_Logins l 
 inner join company_Users u
 on u.Id = l.UserId;
