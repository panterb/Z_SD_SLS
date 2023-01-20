extend view entity E_SalesDocumentBasic with
    association [0..1] to I_Currency as _zz_grossamountcurrency_sdh on $projection.zz_grossamountcurrency_sdh = _zz_grossamountcurrency_sdh.Currency 
 {
    @Semantics.amount.currencyCode: 'zz_grossamountcurrency_sdh'
    Persistence.zz_grossamount_sdh as zz_grossamount_sdh,
    @ObjectModel.foreignKey.association: '_zz_grossamountcurrency_sdh'
    Persistence.zz_grossamountcurrency_sdh as zz_grossamountcurrency_sdh,
    
    _zz_grossamountcurrency_sdh
}
