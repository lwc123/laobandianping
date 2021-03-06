﻿using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;

namespace JXBC.Workplace.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial interface IServiceContractRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="buyerId"></param>
        /// <returns></returns>
        ServiceContract FindLastOneByBuyer(long buyerId);        
    }    
}