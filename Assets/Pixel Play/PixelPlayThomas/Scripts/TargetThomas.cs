
//#define Debug

using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace PoloGames
{
    public class TargetThomas : MonoBehaviour
    {
        [SerializeField]
        private List<Indicator> indicatorModels;
        private List<int> indicatorIDs;
        public void Start()
        {
            indicatorIDs = new List<int>();
#if Debug
            Debug.Log("start" + gameObject.name);
#endif
            foreach(Indicator indicator in indicatorModels)
            {
                
                indicatorIDs.Add(TargetPool.instance.grow(indicator));
            }
            
        }

        public Indicator GetIndicator(int indicatorRank)
        {
            return TargetPool.instance.GetIndicator(indicatorIDs[indicatorRank]);
        }
    }





}

