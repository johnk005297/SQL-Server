USE Operational
--create view [cust.PITeqmt] as

GO


--declare @shiftStart int = (select MAX(ShiftStartTimestamp) from common.ShiftInfo)
--declare @curshift int = (select ShiftId from common.ShiftInfo where ShiftStartTimestamp = (select MAX(ShiftStartTimestamp) from Common.ShiftInfo))
--declare @curShift int = (select max(ShiftId)from common.ShiftInfo)  -- Second way to perform select from the last shift.

select 
	 [Truck].FieldId as eqmt	
	-- ,CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,(DATEADD(s, [Truck].FieldLaststatustime, '1970-01-01'))),DATENAME(tzoffset,SYSDATETIMEOFFSET())))
	,DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), DATEADD(s, [Truck].FieldLaststatustime, '1970-01-01'))
		as statustime
	,[PITloc3].FieldId as lastloc
	,[PITloc4].FieldId as nextloc
	,[PITloc2].FieldId as pit	
	,[Enum1].[Description] as nextact
	,[Enum2].[Description] as lastact
	,[Enum3].[Description] as material		
	,[Shiftreason].FieldName as reason
	,[Truck].FieldReason as lastreasonno
	--,[Enum_status].[Description] as laststatusno
	,[Truck].FieldStatus as laststatusno
	,[Truck].FieldXloc as x
	,[Truck].FieldYloc as y
	,[PITloc3].FieldZloc as z
	,[Auxeqmt].FieldId as van
	,DATEADD(SS, [Truck].FieldTimelast + (select MAX(ShiftStartTimestamp) from common.ShiftInfo), '1970-01-01') as actiontime
	,[Excav].FieldId as excav
	--,[Worker].FieldName as operatorname
	,NULLIF([Truck].FieldCuroper,-1) as operator
	,DATEADD(SS, [Truck].FieldTime1 + (select MAX(ShiftStartTimestamp) from common.ShiftInfo), '1970-01-01') as timeatshovel
	,[PITloc5].FieldId as dumpasn	
	,CASE 
		when [Truck].FieldStatus = '196' THEN [Pitloc4].FieldId
		ELSE NULL 
	 END as tdownprm
	,DATEADD(SS, [Truck].FieldTimenext + (select MAX(ShiftStartTimestamp) from common.ShiftInfo),'1970-01-01') as timenext
	,DATEADD(SS, [Truck].FieldLastgpsupdate,'1970-01-01') as lastgpsupdate
	,[Truck].FieldTons as tons
	,[Truck].FieldVelocity as speed
	,[Truck].FieldHeading as head	

from dbo.PITTruck as [Truck] (nolock)
	left join PITPitloc		   as [PITloc3] (nolock) on [Truck].FieldLoc = [PITloc3].Id
	left join PITPitloc		   as [PITloc4] (nolock) on [Truck].FieldLocnext = [PITloc4].Id
	left join PITPitloc		   as [PITloc]  (nolock) on [PITloc].Id = [Truck].FieldLoc
	left join PITPitloc		   as [PITloc2] (nolock) on [PITloc2].Id = [PITloc].FieldPit
	left join dbo.Enum		   as [Enum1]   (nolock) on [Enum1].Id = [Truck].FieldActnext
	left join dbo.Enum		   as [Enum2]   (nolock) on [Enum2].Id = [Truck].FieldActlast
	left join dbo.Enum		   as [Enum3]   (nolock) on [Enum3].Id = [Truck].FieldLoad
	left join dbo.Enum		   as [Enum_status]   (nolock) on [Enum_status].Id = [Truck].FieldStatus
	left join SHIFTShiftreason as [Shiftreason] (nolock) on [Shiftreason].FieldReason = [Truck].FieldReason 
        and [Shiftreason].FieldStatus = [Truck].FieldStatus and [Shiftreason].ShiftId = 
		(select ShiftId from common.ShiftInfo where ShiftStartTimestamp = (select MAX(ShiftStartTimestamp) from Common.ShiftInfo))
	left join PITAuxeqmt	   as [Auxeqmt] (nolock) on [Auxeqmt].Id = [Truck].FieldVan
	left join PITExcav		   as [Excav]   (nolock) on [Excav].Id = [Truck].FieldLastexcav
	--left join PITWorker		   as [Worker]  (nolock) on [Worker].id = [Truck].FieldCuroper
	left join PITPitloc		   as [PITloc5] (nolock) on [Truck].FieldDumpasn = [PITloc5].Id
	
UNION ALL


select 
	[Excav].FieldId as eqmt	
	-- ,CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,(DATEADD(s, [Truck].FieldLaststatustime, '1970-01-01'))),DATENAME(tzoffset,SYSDATETIMEOFFSET())))
	,DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), DATEADD(s, [Excav].FieldLaststatustime, '1970-01-01'))
		as statustime
	,[PITloc3].FieldId as lastloc
	,[PITloc4].FieldId as nextloc
	,[PITloc2].FieldId as pit	
	,[Enum1].[Description] as nextact
	,[Enum2].[Description] as lastact
	,[Enum3].[Description] as material		
	,[Shiftreason].FieldName as reason
	,[Excav].FieldReason as lastreasonno
	--,[Enum_status].[Description] as laststatusno
	,[Excav].FieldStatus as laststatusno
	,[Excav].FieldXloc as x
	,[Excav].FieldYloc as y
	,[PITloc3].FieldZloc as z
	,[Auxeqmt].FieldId as van
	,DATEADD(SS,[excav].FieldTimelast + (select MAX(ShiftStartTimestamp) from common.ShiftInfo), '1970-01-01') as actiontime
	,NULL as excav
	,NULLIF([Excav].FieldCuroper,-1) as operator
	,NULL as timeatshovel
	,NULL as dumpasn
	,CASE 
		when [Excav].FieldStatus = '196' THEN [Pitloc4].FieldId
		ELSE NULL 
	 END as tdownprm
	,DATEADD(SS, [Excav].FieldTimenext + (select MAX(ShiftStartTimestamp) from common.ShiftInfo),'1970-01-01') as timenext
	,DATEADD(SS, [Excav].FieldLastgpsupdate,'1970-01-01') as lastgpsupdate
	,[Excav].FieldTons as tons
	,[Excav].FieldVelocity as speed
	,[Excav].FieldHeading as head


from dbo.PITExcav as [Excav]
left join PITPitloc		   as [PITloc3] (nolock) on [Excav].FieldLoc = [PITloc3].Id  -- current location
	left join PITPitloc		   as [PITloc4] (nolock) on [Excav].FieldLocnext = [PITloc4].Id  -- next location
	left join PITPitloc		   as [PITloc]  (nolock) on [PITloc].Id = [Excav].FieldLoc
	left join PITPitloc		   as [PITloc2] (nolock) on [PITloc2].Id = [PITloc].FieldPit
	left join dbo.Enum		   as [Enum1]   (nolock) on [Enum1].Id = [Excav].FieldActnext
	left join dbo.Enum		   as [Enum2]   (nolock) on [Enum2].Id = [Excav].FieldActlast
	left join dbo.Enum		   as [Enum3]   (nolock) on [Enum3].Id = [Excav].FieldLoad
	left join SHIFTShiftreason as [Shiftreason] (nolock) on [Shiftreason].FieldReason = [Excav].FieldReason 
        and [Shiftreason].FieldStatus = [Excav].FieldStatus and [Shiftreason].ShiftId = 
		(select ShiftId from common.ShiftInfo where ShiftStartTimestamp = (select MAX(ShiftStartTimestamp) from Common.ShiftInfo))
	left join dbo.Enum		   as [Enum_status]   (nolock) on [Enum_status].Id = [Excav].FieldStatus
	left join PITAuxeqmt	   as [Auxeqmt] (nolock) on [Auxeqmt].Id = Excav.FieldVan


UNION ALL

    select 
	 [auxeqmt].FieldId as eqmt
	,DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), DATEADD(s, [AuxEqmt].FieldLaststatustime, '1970-01-01'))	as statustime
	,[PITloc3].FieldId as lastloc
	,[PITloc4].FieldId as nextloc
	,[PITloc2].FieldId as pit
	,[Enum1].[Description] as nextact
	,[Enum2].[Description] as lastact
	,NULL	as material
	,[Shiftreason].FieldName as reason
	,[AuxEqmt].FieldReason as lastreasonno
	,[AuxEqmt].FieldStatus as laststatusno
	,[AuxEqmt].FieldXloc as x
	,[AuxEqmt].FieldYloc as y
	,[AuxEqmt].FieldZ    as z
	,[AuxEqmt2].FieldId  as van
	,DATEADD(SS,[AuxEqmt].FieldTimelast + (select MAX(ShiftStartTimestamp) from common.ShiftInfo), '1970-01-01') as actiontime
	,NULL as excav
	,NULLIF([AuxEqmt].FieldCuroper, -1) as operator
	,NULL as timeatshovel
	,NULL as dumpasn
	,CASE
		when [AuxEqmt].FieldStatus = '196' then [pitloc4].FieldId
		else NULL
	 END as tdownprm
	,DATEADD(SS, [AuxEqmt].FieldTimenext + (select MAX(ShiftStartTimestamp) from common.ShiftInfo),'1970-01-01') as timenext
	,DATEADD(SS, [AuxEqmt].FieldLastgpsupdate,'1970-01-01') as lastgpsupdate
	,NULL as tons
	,[AuxEqmt].FieldVelocity as speed
	,[AuxEqmt].FieldHeading as head

from PITAuxeqmt as [AuxEqmt]
	left join PITPitloc	  as [PITloc3] (nolock) on [AuxEqmt].FieldLoc = [PITloc3].Id  -- current location
	left join PITPitloc   as [PITloc4] (nolock) on [AuxEqmt].FieldLocnext = [PITloc4].Id  -- next location
	left join PITPitloc	  as [PITloc]  (nolock) on [PITloc].Id = [AuxEqmt].FieldLoc
	left join PITPitloc	  as [PITloc2] (nolock) on [PITloc2].Id = [PITloc].FieldPit
	left join dbo.Enum	  as [Enum1]   (nolock) on [Enum1].Id = [AuxEqmt].FieldActnext
	left join dbo.Enum	  as [Enum2]   (nolock) on [Enum2].Id = [AuxEqmt].FieldActlast	
	left join SHIFTShiftreason as [Shiftreason] (nolock) on [Shiftreason].FieldReason = [AuxEqmt].FieldReason 
        and [Shiftreason].FieldStatus = [AuxEqmt].FieldStatus and [Shiftreason].ShiftId = 
		(select ShiftId from common.ShiftInfo where ShiftStartTimestamp = (select MAX(ShiftStartTimestamp) from Common.ShiftInfo))
	left join PITAuxeqmt as [AuxEqmt2] (nolock) on [AuxEqmt].Id = [AuxEqmt2].FieldVan
	

GO
