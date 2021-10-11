using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Core
{
    [CreateAssetMenu(fileName = "PoolsManager", menuName = "MyDatas/PoolsManager")]
    public class PoolsManager : ScriptableObject
    {
        static PoolsManager instance=null;
        static PoolsManager Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = Resources.Load("PoolsManager") as PoolsManager;
                    instance.Initialise();
                }
                return instance;

            }
        }

        [SerializeField] SerialisablePoolDictionnary pools = new SerialisablePoolDictionnary();

        void Initialise()
        {
            foreach(KeyValuePair<PooledType,Pool> pool in pools)
            {
                pool.Value.FillQueue();
            }

        }

        public static GameObject GetPooled(PooledType pooledType)
        {
            return Instance.pools[pooledType].GetProjectileFromPool();
        }



    }
}

