using System.Collections;
using System.Collections.Generic;
using Mirror;
using UnityEngine;
using UnityEditor;
using UnityEngine.UI;

namespace TestScripts
{
    public class DespawnObject : NetworkBehaviour
    {
        private void Update()
        {
            if(isServer&& Input.GetKey(KeyCode.Alpha0))
            {
                NetworkServer.Destroy(gameObject);
            }
        }



    }
}
