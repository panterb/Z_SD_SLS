extend view entity R_SalesOrderTP with 
 {
    @Semantics.amount.currencyCode: 'zz_grossamountcurrency_sdh'
    _Extension.zz_grossamount_sdh as zz_grossamount_sdh,
    _Extension.zz_grossamountcurrency_sdh as zz_grossamountcurrency_sdh
 }
