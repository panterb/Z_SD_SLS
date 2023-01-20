extend view entity E_SalesDocumentBasic with
    association [0..1] to I_Currency as _zz_giftcardcurrency_sdh on $projection.zz_giftcardcurrency_sdh = _zz_giftcardcurrency_sdh.Currency 
 {
    @Semantics.amount.currencyCode: 'zz_giftcardcurrency_sdh'
    Persistence.zz_giftcardamount_sdh as zz_giftcardamount_sdh,
    @ObjectModel.foreignKey.association: '_zz_giftcardcurrency_sdh'
    Persistence.zz_giftcardcurrency_sdh as zz_giftcardcurrency_sdh,
    
    _zz_giftcardcurrency_sdh
}
