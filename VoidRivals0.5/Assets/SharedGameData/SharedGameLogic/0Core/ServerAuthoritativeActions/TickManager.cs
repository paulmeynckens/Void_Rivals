using UnityEngine;
using System.Collections;
using Mirror;

namespace Core.ServerAuthoritativeActions
{
    public class TickManager : NetworkBehaviour
    {

        public static ushort Tick = 0;

        static TickManager singleton = null;

        private void Awake()
        {
            if (singleton!=null)
            {
                Destroy(this);
                return;
            }
            singleton = this;
        }

        

        private void FixedUpdate()
        {
            //Tick++;
            ushort newtick = (ushort)(NetworkTime.time / Time.fixedDeltaTime);
            if (Tick == newtick)
            {
                Tick++;
            }
            else
            {
                Tick = newtick;
            }

        }
        public override void OnStartServer()
        {
            base.OnStartServer();
            Tick = 0;
        }
        public override void OnStartClient()
        {
            base.OnStartClient();
            Tick = (ushort)(NetworkTime.time / Time.fixedDeltaTime);
        }

    }
}