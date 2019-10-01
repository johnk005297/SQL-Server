
--- Выгрузка администраторов холдинга, включая заблокированных и удаленных ---

select l.loginname login, l.passwordHash, l.Discriminator, 
	case		
		when u.Deleted = 1 then 'DELETED'
		when u.Blocked = 1 then 'BLOCKED'		
		else 'active'
	end Status		
	from boardmaps_Logins l
inner join boardmaps_Users u
on l.UserId = u.Id
inner join (select a.UserId from boardmaps_AccessControlList a
	where a.RoleId =
		( select id from boardmaps_RoleModel_RoleTypes r 
				where BuiltinType = 'HoldingAdministrator' and HoldingId is not null ) and a.Deleted = 0 group by a.UserId ) r
		on r.UserId = l.UserId
	order by Status;
		
		
		
		
		
		
----  Второй вариант: выводит два запроса - админов холдинга, затем всех пользователей с указанием стандартных паролей ----
select l.loginname HoldingAdmins, 
case 
when l.passwordHash = 'vFRQPemIV0HURsKLTF+tO+8uBkI=' then 'qqq111'
when l.passwordHash = 'CZInYdVykek6IMCEw9ql3DMQMG0=' then 'demo321'
when l.passwordHash = 'LA4qU++A26qKuOlXFZVrTl1itpQ=' then 'www222'
when l.passwordHash = '3q/vHsQzO5UwbOTSdg7AJw75q0c=' then 'admin123'
when l.passwordHash = '3QHrhRk2AGx8op4NtDTzDZoTGzs=' then 'Admdemo'
else l.passwordHash
end passwordOrHash,
  l.Discriminator,
case
when u.Deleted = 1 then 'DELETED'
when u.Blocked = 1 then 'BLOCKED'
else 'active'
end Status
from boardmaps_Logins l
inner join boardmaps_Users u
on l.UserId = u.Id
inner join (select a.UserId from boardmaps_AccessControlList a
where a.RoleId =
( select id from boardmaps_RoleModel_RoleTypes 
where BuiltinType = 'HoldingAdministrator' and HoldingId is not null ) and a.Deleted = 0 group by a.UserId ) r
on r.UserId = l.UserId
order by Status;


select l.LoginName Users, 
case
	when l.passwordHash = 'vFRQPemIV0HURsKLTF+tO+8uBkI=' then 'qqq111'
	when l.passwordHash = 'ws7hfnvigyEAkN113/rQkzTEBGg=' then '123'
	when l.passwordHash = 'CZInYdVykek6IMCEw9ql3DMQMG0=' then 'demo321'
	when l.passwordHash = 'LA4qU++A26qKuOlXFZVrTl1itpQ=' then 'www222'
	when l.passwordHash = '3q/vHsQzO5UwbOTSdg7AJw75q0c=' then 'admin123'
	when l.passwordHash = '3QHrhRk2AGx8op4NtDTzDZoTGzs=' then 'Admdemo'
	else l.passwordHash
end passwordOrHash, Discriminator, 
case
	when u.Deleted = 1 then 'DELETED'
	when u.Blocked = 1 then 'BLOCKED'
	else 'active'
end Status
 from boardmaps_Logins l 
 inner join boardmaps_Users u
 on u.Id = l.UserId;
