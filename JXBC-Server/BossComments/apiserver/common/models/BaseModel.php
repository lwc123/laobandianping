<?php

namespace app\common\models;
use think\Db;
use think\Model;
use think\Config;
use app\common\modules\DbHelper;
 
class BaseModel extends Model {
	
    protected static function init()
    {
        self::event('before_insert',function($entity){
        	$pkName = $entity->getPk();
        	if(empty($entity->data[$pkName])){
        		unset($entity->data[$pkName]);
        	}
        	
            self::formatDatetimeToDB($entity);
        });  
        self::event('before_update',function($entity){
            self::formatDatetimeToDB($entity);
        }); 
  
    }
    
    protected static function formatDatetimeToDB($entity) {    	
       // echo json_encode($entity->data);
        foreach ($entity->data as $key => $value) {
        	foreach ($entity->type as $propName =>$propType) {
        		if($propName == $key) {
        			if($propType =="datetime" ) {
                        $entity->data[$key] = DbHelper::toLocalDateTime($entity[$key]);
        			}
        			break;
        		}
        	}
        } 
        // echo json_encode($entity->data);
    }

    /**
     * 根据关联条件加载指定子模型的数据
     * @access public
     * @param $source     $sources 当前模型的实例（或数据列表）
     * @param arrayu    $relationes 关联模型定义[attr:父模型属性名；model:子模型名称；order:排序条件，默认排序时可忽略；foreignKey:子模型的关联外键，与父模型一致时可忽略]
     * @return $sources
     */
    protected static function loadChildren($source, array $relationes)
    {
        if(empty($source) || (is_array($source) && count($source) < 1)) {
            return $source;
        };
        $db = self::getDb();
        $model = new static();
        $pkName =$model->getPk();
        $ids = [];
        if(is_array($source)) {
            foreach ($source as $item) {
                $ids[] = $item[$pkName];
            }
        } else {
            $ids[] = $source[$pkName];
        }
;
        foreach ($relationes as $relation) {
            $subModel = $relation["model"];
            $foreignKey = array_key_exists("foreignKey",$relation) ? $relation["foreignKey"] : $pkName;
            $sql = $db->table($db->getTable($subModel))->where($foreignKey,'in',$ids)->order($relation["order"])->select(false);
            $dataTable = $db->query($sql);

            if(!empty($dataTable)){
                if(is_array($source)) {
                    foreach ($source as $item) {
                        $item[$relation["attr"]] = self::findChildren($dataTable,$foreignKey, $item, $pkName);

                    }
                } else {
                    $source[$relation["attr"]] = self::findChildren($dataTable,$foreignKey, $source, $pkName);
                }
            }
        }
        return $source;
    }

    private static function findChildren($dataTable,$foreignKey,$parent, $parentPkName) {
        $list=[];
        foreach ($dataTable as $dataRow) {
            if($dataRow[$foreignKey] == $parent[$parentPkName]) {
                $list[] = $dataRow;
            }
        }
        return $list;
    }
    protected $autoWriteTimestamp = "datetime";
    protected $createTime = 'CreatedTime';
    protected $updateTime = 'ModifiedTime';
    protected $dateFormat = DbHelper::UtcDateFormat;
    
    protected $type = [
        'CreatedTime'   => 'datetime',
        'ModifiedTime'  => 'datetime' 
    ];
    
    //处理钱
    protected function getMoneyWithDBUnit($value)
    {
    	return $value/Config::get('db_currency_unit');
    }
    
    protected function setMoneyWithDBUnit($value)
    {
    	return $value * Config::get('db_currency_unit');
    }
    
    //处理资源路径
    
    public function getResourcesSiteRoot($value)
    {
    	return Config('resources_site_root').$value;
    }
    
    public function setResourcesSiteRoot($value)
    {
    	return str_replace(Config('resources_site_root'), '', $value);
    }
    
    protected function writeTransform($value, $type) 
    {
    	if (is_array($type)) {
    		list($type, $param) = $type;
    	} elseif (strpos($type, ':')) {
    		list($type, $param) = explode(':', $type, 2);
    	}
    	switch ($type) {
    		case 'datetime':
                $format = !empty($param) ? $param : $this->dateFormat;
                return is_numeric($value) ? date($format, $value) : DbHelper::toLocalDateTime($value);
            default:
            	return parent::writeTransform($value, $type);
    	}
    }
    
    protected function readTransform($value, $type)
    {
    	if (is_array($type)) {
    		list($type, $param) = $type;
    	} elseif (strpos($type, ':')) {
    		list($type, $param) = explode(':', $type, 2);
    	}
    	switch ($type) {
    		case 'datetime':
    			if (!is_null($value)) {
                    $value  = DbHelper::toUtcDateTime($value);
                }
                break;
    		default:
    			$value  = parent::readTransform($value, $type);
    	}
    	return $value;
    }
    
    protected function autoWriteTimestamp($name)
    {
        $this->dateFormat = DbHelper::LocalDateFormat;
        $value = parent::autoWriteTimestamp($name);
        $this->dateFormat = DbHelper::UtcDateFormat;
        
        return $value;
    }
}
