using UnityEngine;
using System.Collections;
using Mirror;

namespace Core.ServerAuthoritativeActions
{
    public class TickManager : MonoBehaviour
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

        private void Start()
        {

            Tick = (ushort)(NetworkTime.time / Time.fixedDeltaTime);
        }

    }
}