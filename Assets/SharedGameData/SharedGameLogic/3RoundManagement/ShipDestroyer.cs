using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;
using Mirror;
using ShipsLogic.Holes;
using CharacterLogic;

namespace RoundManagement
{
    public class ShipDestroyer : NetworkBehaviour
    {
        Structure structure=null;
        BodiesHolder bodiesHolder=null;
        private void Awake()
        {
            bodiesHolder = GetComponent<BodiesHolder>();
        }

        public override void OnStartServer()
        {
            base.OnStartServer();
            structure = GetComponent<Structure>();
            structure.OnServerDie += ServerKillPlayersAndDestroyShip;
        }

        /// <summary>
        /// kill all the players on board and destroys itself.
        /// </summary>
        void ServerKillPlayersAndDestroyShip()
        {
            
            

            StartCoroutine(ServerWaitAndDestroy());
            
        }
        IEnumerator ServerWaitAndDestroy()
        {
            yield return new WaitForSeconds(5);

            CharacterHealth[] characterHealths = transform.GetComponentsInChildren<CharacterHealth>();
            foreach (CharacterHealth characterHealth in characterHealths)
            {
                characterHealth.ServerPulverize();
            }
            NetworkServer.Destroy(this.gameObject);
        }
    }
}
