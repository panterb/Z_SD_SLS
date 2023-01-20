extend view entity R_SalesOrderTP with 
 {
    @Semantics.amount.currencyCode: 'zz_giftcardcurrency_sdh'
    _Extension.zz_giftcardamount_sdh as zz_giftcardamount_sdh,
    _Extension.zz_giftcardcurrency_sdh as zz_giftcardcurrency_sdh
 }
