//= require jquery
//= require jquery_ujs
//= require bootstrap/js/bootstrap.min
//= require moment/moment
//
//
//= require components/admin/common/metronic
//= require components/admin/common/layout
//= require components/admin/common/index
//= require components/admin/table-ajax/index
//
//
//= require_self



$(function() {
    var el = $('body');


    Metronic.init(); // init metronic core componets
    Layout.init(); // init layout
    Demo.init(); // init demo features

    //init table-managed
    TableAjax.init(el.find('.com-datatable-ajax'), {
        'columnDefs': [{
            "targets": [0],
            "data": "id",
            "render": function(data, type, full) {
                return "<input type=\"checkbox\" name=\"id[]\" value=\"" + data + "\">";
            }
        }, {
            "targets": [1],
            "orderable": false,
            "data": "file_file_name",
            "name": "file_file_name"
        }, {
            "targets": [2],
            "orderable": false,
            "data": "file_content_type",
            "name": "file_content_type"
        }, {
            "targets": [3],
            "orderable": false,
            "data": "file_file_size",
            "name": "file_file_size"
        }, {
            "targets": [4],
            "orderable": false,
            "data": "file_updated_at",
            "name": "file_updated_at"
        },  {
            "targets": [5],
            "orderable": false,
            "data": "file_state",
            "name": "file_state"
        }, {
            "targets": [6],
            "data": "id",
            "orderable": false,
            "render": function(data, type, full) {
                   return '<a href="/admin/documents/' + data + '" class="btn default btn-xs black" data-method="delete" data-confirm="确定删除此条记录吗？"><i class="fa fa-trash-o"></i> 删除</a>';
            }
        }],
    });
});
