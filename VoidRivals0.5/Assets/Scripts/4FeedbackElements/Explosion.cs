using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;
using System;

namespace FeedbackElements
{
    public class Explosion : MonoBehaviour, IPooled
    {


        public event Action<IPooled> OnReturnToPool;

        // Start is called before the first frame update
        private void OnDisable()
        {
            OnReturnToPool?.Invoke(this);
        }
    }
}

