//= require components/admin/common/datatable
//= require datatables/media/js/jquery.dataTables
//= require datatables/plugins/bootstrap/dataTables.bootstrap
//= require uniform/jquery.uniform.min
//= require select2/js/select2
//= require bootstrap-datepicker/js/bootstrap-datepicker
//
//= require_self
//


var TableAjax = function() {

    var initPickers = function(el) {
        //init date pickers
        el.find('.date-picker').datepicker({
            rtl: Metronic.isRTL(),
            autoclose: true
        });
    }

    var handleRecords = function(el, opts) {

        var grid = new Datatable();

        grid.init({
            src: el,
            onSuccess: function(grid) {
                // execute some code after table records loaded
            },
            onError: function(grid) {
                // execute some code on network or other general error  
            },
            onDataLoad: function(grid) {
                // execute some code on ajax data load
            },
            loadingMessage: 'Loading...',
            dataTable: $.extend({
                // here you can define a typical datatable settings from http://datatables.net/usage/options 
                // Uncomment below line("dom" parameter) to fix the dropdown overflow issue in the datatable cells. The default datatable layout
                // setup uses scrollable div(table-scrollable) with overflow:auto to enable vertical scroll(see: assets/global/scripts/datatable.js). 
                // So when dropdowns used the scrollable div should be removed. 
                //"dom": "<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'<'table-group-actions pull-right'>>r>t<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'>>",

                "bStateSave": true, // save datatable state(pagination, sort, etc) in cookie.
                "lengthMenu": [
                    [10, 20, 50, 100, -1],
                    [10, 20, 50, 100, "All"] // change per page values here
                ],
                "pageLength": 10, // default record count per page
                "ajax": {
                    "url": el.attr('data-url'), // ajax source
                },
                "order": [
                        [1, "asc"]
                    ] // set first column as a default sort by asc
            }, opts)
        });

        // handle group actionsubmit button click
        grid.getTableWrapper().on('click', '.table-group-action-submit', function(e) {
            e.preventDefault();
            var action = $(".table-group-action-input", grid.getTableWrapper());
            if (action.val() != "" && grid.getSelectedRowsCount() > 0) {
                grid.setAjaxParam("customActionType", "group_action");
                grid.setAjaxParam("customActionName", action.val());
                grid.setAjaxParam("id", grid.getSelectedRows());
                grid.getDataTable().ajax.reload();
                grid.clearAjaxParams();
            } else if (action.val() == "") {
                Metronic.alert({
                    type: 'danger',
                    icon: 'warning',
                    message: '请选择你要执行的操作',
                    container: grid.getTableWrapper(),
                    place: 'prepend'
                });
            } else if (grid.getSelectedRowsCount() === 0) {
                Metronic.alert({
                    type: 'danger',
                    icon: 'warning',
                    message: '当前无选中项',
                    container: grid.getTableWrapper(),
                    place: 'prepend'
                });
            }
        });

        window.COMS = window.COMS || [];
        el.data('initialized', true);
        el.data('guid', window.COMS.length);
        window.COMS.push(grid);
    }

    return {

        //main function to initiate the module
        init: function(els, opts) {
            if (typeof els == 'string') {
                els = $(els);
            }

            els.each(function() {
                var el = $(this);

                initPickers(el);
                handleRecords(el, opts);
            });
        }
    };
}();
