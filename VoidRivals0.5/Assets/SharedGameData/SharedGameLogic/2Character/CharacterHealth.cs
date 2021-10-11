﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using Mirror;
using System;
using Core;



namespace CharacterLogic
{
    public class CharacterHealth : Health
    {
        public event Action OnServerPulverized;
        public void ServerPulverize()
        {
            OnServerPulverized?.Invoke();

        }
        public override void ServerDie()
        {
            base.ServerDie();
            StartCoroutine(WaitAndRemoveBody());
        }

        IEnumerator WaitAndRemoveBody()
        {
            yield return new WaitForSeconds(10);
            NetworkServer.Destroy(gameObject);
        }
    }
}

