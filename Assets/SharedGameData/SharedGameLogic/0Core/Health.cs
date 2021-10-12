using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using System;

namespace Core
{
    public class Health : NetworkBehaviour,IChangeQuantity
    {
        protected short maxHealth;

        protected ICanDie[] aliveOrDeads;


        public event Action<short, short> OnChangeQuantity;

        public event Action OnServerDie = delegate { };
        public event Action OnClientDie = delegate { };

        #region SynVars +hooks

        [SyncVar(hook = nameof(ClientUpdateHealthVisual))] public short currentHealth = 100;
        void ClientUpdateHealthVisual(short _old, short _new)
        {
            OnChangeQuantity?.Invoke(_new, maxHealth);
        }
        
        #endregion

        protected virtual void Awake()
        {
            aliveOrDeads = GetComponents<ICanDie>();
        }

        #region Server

        public override void OnStartServer()
        {
            base.OnStartServer();
            maxHealth = currentHealth;
        }



        public virtual void ServerDealDamage(short damage, Vector3 hitPosition)
        {
            currentHealth -= damage;
            if (currentHealth < 0)
            {
                currentHealth = 0;
                ServerDie();
            }
        }


        public void ServerHeal(short healingAmount)
        {
            currentHealth += (short)healingAmount;
            if (currentHealth > maxHealth)
            {
                currentHealth = maxHealth;
            }
        }

        public void ServerHealFull()
        {
            currentHealth = maxHealth;
        }

        
        public virtual void ServerDie()
        {
            OnServerDie?.Invoke();
            //Die();
            RpcDie();
        }



        #endregion

        #region Both sides
        void Die()
        {
            foreach (ICanDie canDie in aliveOrDeads)
            {
                canDie.Kill();
            }
        }

        #endregion

        #region RPCs

        [ClientRpc]
        void RpcDie()
        {
            //Die();
            OnClientDie();
        }

        #endregion

    }
}



