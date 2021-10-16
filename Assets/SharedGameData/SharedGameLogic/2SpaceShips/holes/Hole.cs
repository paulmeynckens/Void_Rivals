using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;
using Core.Interractables;

namespace ShipsLogic.Holes

{
    public class Hole : Workable
    {
        [SerializeField] Transform holeBody = null;




        public short damage = 0;

        const float MINIMUM_SCALE = 0.2f;
        const short MAXIMUM_DAMAGE = 500;

        public event Action<Hole> OnServerHoleRepair;

        protected override void Awake()
        {
            base.Awake();
            Debug.Log("poping hole");
        }
        protected override void OnServerWorkFinished()
        {
            base.OnServerWorkFinished();
            OnServerHoleRepair?.Invoke(this);
        }

        #region SyncVars+hooks


        protected override void ClientChangeVisual(short _old, short _new)
        {
            base.ClientChangeVisual(_old, _new);
            float newScale = MINIMUM_SCALE + ((1 - MINIMUM_SCALE) * _new / MAXIMUM_DAMAGE);
            Vector3 scale;
            scale.x = newScale;
            scale.y = newScale;
            scale.z = 1;

            holeBody.transform.localScale = scale;
        }


        #endregion








    }
}



