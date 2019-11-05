
-- Запрос выгружает пользователей с конкретными правами в системе, проверяя статус блокировки или удаления


select l.loginname HoldingAdmins, 
case 
when l.passwordHash = 'vFRQPemIV0HURsKLTF+tO+8uBkI=' then 'qqq111'
when l.passwordHash = 'CZInYdVykek6IMCEw9ql3DMQMG0=' then 'demo321'
when l.passwordHash = 'LA4qU++A26qKuOlXFZVrTl1itpQ=' then 'www222'
when l.passwordHash = '3q/vHsQzO5UwbOTSdg7AJw75q0c=' then 'admin123'
when l.passwordHash = '3QHrhRk2AGx8op4NtDTzDZoTGzs=' then 'Admdemo'
else l.passwordHash
end passwordHash,
  l.Discriminator,
case
when u.Deleted = 1 then 'DELETED'
when u.Blocked = 1 then 'BLOCKED'
else 'active'
end Status
from company_Logins l
inner join company_Users u
on l.UserId = u.Id
inner join (select a.UserId from company_AccessControlList a
where a.RoleId =
( select id from company_RoleModel_RoleTypes 
where BuiltinType = 'HoldingAdministrator' and HoldingId is not null ) and a.Deleted = 0 group by a.UserId ) r
on r.UserId = l.UserId
order by Status;

