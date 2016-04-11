//= require jquery2/jquery
//= require jquery_ujs
//= require bootstrap/js/bootstrap.min
//= require moment/moment
//
//
//= require components/admin/common/metronic
//= require components/admin/common/layout
//= require components/admin/common/index
//= require components/admin/table-ajax/index
//= require components/admin/datepicker/index
//
//
//= require_self

$(function() {

    var el = $('body');

    Metronic.init(); // init metronic core componets
    Layout.init(); // init layout
    Demo.init(); // init demo features
    ComponentsPickers.init();

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
            "data": "post_id",
            "name": "post_id"
        }, {
            "targets": [2],
            "orderable": false,
            "data": "impression_count",
            "name": "impression_count"
        }, {
            "targets": [3],
            "orderable": false,
            "data": "click_count",
            "name": "click_count"
        }, {
            "targets": [4],
            "orderable": false,
            "data": "comment_count",
            "name": "comment_count"
        }, {
            "targets": [5],
            "orderable": false,
            "data": "praise_count",
            "name": "praise_count"
        }, {
            "targets": [6],
            "orderable": false,
            "data": "qq_share",
            "name": "qq_share"
        }, {
            "targets": [7],
            "orderable": false,
            "data": "wechat_share",
            "name": "wechat_share"
        }, {
            "targets": [8],
            "orderable": false,
            "data": "weibo_share",
            "name": "weibo_share",
        }, {
            "targets": [9],
            "orderable": false,
            "data": "genre",
            "name": "genre",
        }, {
            "targets": [10],
            "data": {
              "id": "id",
              "post_id": "post_id"
            },
            "orderable": false,
            "render": function(data, type, full) {
                return '<a href="/admin/sum_messages/' + data.post_id + '" class="btn default btn-xs purple"><i class="fa fa-edit"></i>详情</a>';
            }
        }]
    });

    // 根据时间过滤
    el.on('click', '.filter-form .submit', function(e) {
        e.preventDefault();

        var elCurrentTarget = $(e.currentTarget),
            datetime = el.find('[name="dateMark"]').val(),
            optionsRadios = el.find('[name="optionsRadios"]:checked').val(),
            comId = el.find('.com-datatable-ajax').data('guid'),
            grid = window.COMS[comId];
        grid.setAjaxParam("dateMark", datetime);
        grid.setAjaxParam("optionsRadios", optionsRadios);
        grid.getDataTable().ajax.reload();
        $.ajax({url: "sum_messages/more_sum_message"});
    });
});
