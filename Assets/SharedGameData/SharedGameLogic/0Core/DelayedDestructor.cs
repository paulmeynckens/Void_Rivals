using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Mirror;

namespace Core
{
    public class DelayedDestructor : MonoBehaviour
    {
        public event Action OnServerWillDestroyThisObject = delegate { };
        
        bool coundownIsLaunched = false;
        public bool CoundtownIsLaunched { get => coundownIsLaunched; }
        public void ServerBeginDestruction()
        {
            coundownIsLaunched = true;
            OnServerWillDestroyThisObject();
            StartCoroutine(ServerWaitAndDestroy());
        }
        IEnumerator ServerWaitAndDestroy()
        {
            yield return new WaitForSeconds(5);
            NetworkServer.Destroy(gameObject);
        }
    }
}
