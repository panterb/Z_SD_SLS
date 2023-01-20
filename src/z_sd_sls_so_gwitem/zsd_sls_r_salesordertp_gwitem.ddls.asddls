extend view entity R_SalesOrderTP with
association [0..1] to ZSD_SLS_GOODWILLITEMSTS as _ZZ_GOODWILLITEMSTS_SDH 
  on $projection.zz_goodwillitemstatus_sdh = _ZZ_GOODWILLITEMSTS_SDH.zz_goodwillitemstatus_sdh
{
  @ObjectModel.foreignKey.association: '_ZZ_GOODWILLITEMSTS_SDH'
  _Extension.zz_goodwillitemstatus_sdh as zz_goodwillitemstatus_sdh,

  _ZZ_GOODWILLITEMSTS_SDH
}
