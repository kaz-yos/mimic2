--Primary table
select id.SUBJECT_ID, id.SAPSI_FIRST, id.ICUSTAY_EXPIRE_FLG, id.ICUSTAY_ADMIT_AGE as AGE, ic.CODE, ic.DESCRIPTION
from MIMIC2V26.ICUSTAY_DETAIL id, MIMIC2V26.ICD9 ic
where id.SUBJECT_ID = ic.SUBJECT_ID 
and id.HOSPITAL_FIRST_FLG = 'Y'
and id.ICUSTAY_FIRST_FLG = 'Y'
and id.ICUSTAY_FIRST_CAREUNIT = 'MICU' 
and id.SAPSI_FIRST > 20;

--HCO3 table
select id.SUBJECT_ID, ce.VALUE1NUM as HCO3, ci.LABEL
from MIMIC2V26.ICUSTAY_DETAIL id, MIMIC2V26.ICD9 ic, MIMIC2V26.CHARTEVENTS ce, MIMIC2V26.D_CHARTITEMS ci
where id.SUBJECT_ID = ic.SUBJECT_ID 
and ce.ITEMID = ci.ITEMID
and id.HOSPITAL_FIRST_FLG = 'Y'
and id.ICUSTAY_FIRST_FLG = 'Y'
and id.ICUSTAY_FIRST_CAREUNIT = 'MICU' 
and id.SAPSI_FIRST > 20
and ce.ITEMID = '3810'; --this is the correct HCO3

—-Add WBC
—-Add partial pressure of oxygen (PPO2)
—-Add temperature
* Pull only first lab value for each variable - WHERE ROWNUM <= 1 or FIRST() GROUP BY SUBJECT_ID
* Add Elixhauser?

to pull URINE OUTPUT:
select itemid, label
from d_ioitems
where itemid in (55, 56, 57, 61, 65, 69, 85, 94, 96, 288, 405,
428, 473, 651, 715, 1922, 2042, 2068, 2111, 2119, 2130, 2366, 2463,
2507, 2510, 2592, 2676, 2810, 2859, 3053, 3175, 3462, 3519, 3966, 3987,
4132, 4253, 5927)