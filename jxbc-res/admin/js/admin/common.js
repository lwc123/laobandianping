jQuery(function($) {
    $('.date-picker').datepicker({
        autoclose: true,        
        todayHighlight: true,
        showButtonPanel:true,
        language: 'cn',
        format: "yyyy-mm-dd"
    });
    //show datepicker when clicking on the icon
    $('.date-picker').parent().children('span').on(ace.click_event, function(){  
        $(this).parent().children('input').focus();
    });
    
    $('.chosen-select').chosen({allow_single_deselect:true});

//  $.widget("ui.dialog", $.extend({}, $.ui.dialog.prototype, {
//      _title: function(title) {
//          var $title = this.options.title || '&nbsp;'
//          if( ("title_html" in this.options) && this.options.title_html == true )
//              title.html($title);
//          else title.text($title);
//      }
//  }));
//  
    
    window.__sidebarMenus = {
        _queryName: "__m__",
        _rootMenuId: "$-1",
        _menuAttrName: "menu-id",
        _containerId: "menu-sidebar",
        menuItems: [],
        menuLinks: [],        
        currentMenuItem: null,
        init: function(containerId, menuId) {
            var $container = $("#"+this._containerId);
            $container.data(this._menuAttrName,this._rootMenuId);
            this.appendSubMenus($container);
        },
        appendSubMenus: function(parent, parentMenuId) {            
            if(typeof(parentMenuId)=='undefined' || parentMenuId == null  || parentMenuId.length < 1)
                parentMenuId = parent.data(this._menuAttrName);
            
            
            var index = 0;
            var $menus = this;
            parent.children('li').each(function(){
                index++;
                
                var $item = $(this);
                var itemMenuId = $item.data($menus._menuAttrName);
                
                if(typeof(itemMenuId)=='undefined' || itemMenuId.length<1) {
                    itemMenuId = parentMenuId + '-' + index;
                    $item.data($menus._menuAttrName,itemMenuId);
                }                
                
                var links = $item.children('a');                
                if(links.length == 1) {
                    var href = links.first().attr('href');
                    if(typeof(itemMenuId)!='undefined' || itemMenuId.length>1) {
                        href = href.toLowerCase();
                        $item.data('link', href);
                        $menus.menuLinks.push([href, $item]);
                    } 
                }
                
                $menus.menuItems.push([itemMenuId, $item]);
                
                var subItems = $item.children('ul');
                if(subItems.length == 1) {
                    $menus.appendSubMenus($(subItems.first()), itemMenuId);
                }
            });
        },
        autoFixed: function() {
            var targetMenuId = this.getUrlParam(this._queryName);
            var matchItemByMenuId = null, matchItemByLink = null;            
            
            if(targetMenuId != null) {
                for(var i=0; i<this.menuItems.length; i++) {
                    var itemId = this.menuItems[i][0];
                    if(itemId==targetMenuId) {                        
                        matchItemByMenuId = this.menuItems[i][1];
                        break;
                    }
                }
            }
            
            var pageUrl = location.pathname + location.search;
            for(var i=0; i<this.menuLinks.length; i++) {
                var link = this.menuLinks[i][0];           
                if(pageUrl.toLowerCase().indexOf(link) >= 0) {                    
                    matchItemByLink = this.menuItems[i][1];
                    break;
                }
            }
            
            //匹配优先级：自定义 MenuId最高， 页面Url其次， 自动生成的MenuId最后匹配
            if(targetMenuId!=null && targetMenuId.indexOf(this._rootMenuId)!=0 && null != matchItemByMenuId) {
                this._fixedMenuItem(matchItemByMenuId);
                console.info("fixed by MenuId: ", matchItemByMenuId.data(this._menuAttrName), matchItemByMenuId.data("link"));
            }
            else if(null != matchItemByLink) {
                this._fixedMenuItem(matchItemByLink);
                console.info("fixed by Link: ", matchItemByLink.data(this._menuAttrName), matchItemByLink.data("link"));
            }
            else  if(null != matchItemByMenuId) {
                this._fixedMenuItem(matchItemByMenuId);
                console.info("fixed by MenuId: ", matchItemByMenuId.data(this._menuAttrName), matchItemByMenuId.data("link"));
            }
        },
        
        _fixedParentMenu: function(menuItem) {
            if(menuItem.is("body") || menuItem[0].id == this._containerId) 
                return;
            
            if(menuItem.is("li")) {
                menuItem.addClass("open");
                this._fixedBreadcrumb(menuItem);
            } else {
                this._fixedParentMenu(menuItem.parent());
            }
        },
        _fixedBreadcrumb: function(menuItem) {
            var breadcrumb = $("#breadcrumb");
            if(null!=breadcrumb && breadcrumb.data("action")=="autoFixed") {
                var menuText = menuItem.find("span.menu-text").first().text();
                var children = breadcrumb.children("li");
                if(children.length==2) {
                    var lastCrumb = children.last();
                    if(lastCrumb.text() == menuText) 
                        return;
                }
                var firstCrumb = children.first();                
                firstCrumb.after("<li>"+menuText+"</li>");
            }
        },
        _fixedMenuItem: function(menuItem) {
            this.currentMenuItem = menuItem;
            this.currentMenuItem.addClass("active");
            //this.currentMenuItem.parents("li").addClass("active open");            
            
            this._fixedBreadcrumb(this.currentMenuItem);
            this._fixedParentMenu(this.currentMenuItem.parent());
            
            var queryParam = this._queryName + "=" + this.currentMenuItem.data(this._menuAttrName);
            var $menus = this;
            $("#page-content a").each(function(){
                var $this = $(this);
                var link = $this.attr("href");
                if(typeof(link)=='undefined' || link=="#") return;
                
                var targetMenuId = $this.data($menus._menuAttrName);
                if(typeof(targetMenuId)!='undefined' && targetMenuId.length > 0) return; 
                
                var linkLowerCase = link.toLowerCase();
                var appendMenuId = true;
                for(var i=0; i<$menus.menuLinks.length; i++) {
                    var menuLink = $menus.menuLinks[i][0];                    
                    if(linkLowerCase.indexOf(menuLink) >= 0) {
                        appendMenuId = false;
                        break;
                    }
                }
                if(appendMenuId) {
                    var targetMenuId = $menus.getUrlParam($menus._queryName);
                    
                    if(null == targetMenuId){
                        $this.attr("href",link+(link.indexOf("?")==-1?"?":"&")+queryParam);
                    } else {
                        var baseMenuId = $menus._queryName + "=" + targetMenuId;
                        if(linkLowerCase.indexOf(baseMenuId)>=0) {
                            $this.attr("href",link.replace(baseMenuId, queryParam));
                        } else {
                             $this.attr("href",link+(link.indexOf("?")==-1?"?":"&")+queryParam);
                        }
                    }
                        
                }
            });
        },
        getUrlParam: function(name) {
            if(window.location.search.length < 3) return null;
            
            var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); 
            var r = window.location.search.substr(1).match(reg); 
            if (r != null) return unescape(r[2]); return null; 
        }
    };
    __sidebarMenus.init();
    __sidebarMenus.autoFixed();
});